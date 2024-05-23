using System.Text.RegularExpressions;
using Npgsql;

namespace discord;

class Analyze
{
    static void Main(string[] args)
    {
        var timestamp = DateTime.Now.ToString("yyyyMMddHHmmss");
        var filePath = $"/docker-entrypoint-initdb.d/itogi/query_itogi_{timestamp}.txt";
        var connectionString = "Host=db;Username=postgres;Password=mypassword;Database=discord-db;Port=5432;";
        Console.WriteLine("ANALYZE SERVICE STARTED");

        var attemptCount = int.Parse(Environment.GetEnvironmentVariable("ATTEMPT_COUNT") ?? "4");

        string[] queries =
        {
            """
            SELECT u.username, ur.role_id
            FROM servers AS s
            LEFT JOIN users u ON u.user_id = s.owner_id
            LEFT JOIN user_roles AS ur ON s.server_id = ur.server_id and u.user_id = ur.user_id
            WHERE u.online_status = TRUE and s.server_id = 97664
            """,
            """
            SELECT DISTINCT
                u1.username AS username1,
                u2.username AS username2
            FROM
                user_roles ur1
                    JOIN user_roles ur2 ON ur1.server_id = ur2.server_id AND ur1.user_id <> ur2.user_id
                    JOIN users u1 ON ur1.user_id = u1.user_id
                    JOIN users u2 ON ur2.user_id = u2.user_id
            GROUP BY
                u1.username, u2.username
            HAVING
                COUNT(DISTINCT ur1.server_id) >= 2;
            """,
            """
            SELECT
                s.server_name,
                u.username AS owner_username
            FROM
                servers s
                    JOIN channels c ON s.server_id = c.server_id
                    JOIN users u ON s.owner_id = u.user_id
            WHERE
                c.channel_type = 'text_channel'
            GROUP BY
                s.server_name, u.username;
            """
        };

        var costs = new double[queries.Length][];
        for (var i = 0; i < costs.Length; i++)
        {
            costs[i] = new double[attemptCount];
        }

        try
        {
            using (var writer = new StreamWriter(filePath))
            {
                using (var connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                
                    for (var q = 0; q < queries.Length; q++)
                    {
                        var query = queries[q];
                        Console.WriteLine($"Executing query {q + 1}/{queries.Length}: {query}");
                        for (var a = 0; a < attemptCount; a++)
                        {
                            try
                            {
                                using (var command = new NpgsqlCommand($"EXPLAIN ANALYZE {query}", connection))
                                {
                                    using (var reader = command.ExecuteReader())
                                    {
                                        var res = new List<double>();
                
                                        while (reader.Read())
                                        {
                                            var result = reader.GetString(0);
                                            var match = Regex.Match(result, @"cost=(\d+\.\d+)..(\d+\.\d+)");
                                            if (match.Success)
                                            {
                                                var startCost = double.Parse(match.Groups[1].Value);
                                                var endCost = double.Parse(match.Groups[2].Value);
                                                res.Add(endCost);
                                            }
                                        }
                
                                        if (a == attemptCount - 1)
                                        {
                                            var minC = res.Min();
                                            var maxC = res.Max();
                                            var avgC = res.Average();
                                            writer.WriteLine($"query: {query}\n");
                                            writer.WriteLine($"best case time: {minC}");
                                            writer.WriteLine($"worst case time: {maxC}");
                                            writer.WriteLine($"average case time: {avgC}");
                                            writer.WriteLine('\n');
                
                                        }
                                    }
                                }
                            }
                            catch (Exception ex)
                            {
                                Console.WriteLine($"ERROR: {ex.Message}");
                            }
                        }
                    }
                }
            }

            Console.WriteLine($"RESULTS SAVED: {filePath}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"error writing to file: {ex.Message}");
        }
    }
}