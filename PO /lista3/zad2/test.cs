using System;
using Dictionaries;

class MainClass
{
    public static void Main()
    {
        Dictionary<string, float> dict = new Dictionary<string, float>();

        PrintInstructions();

        bool exit = false;
        Console.Write("$ ");

        while (!exit)
        {
            string input = Console.ReadLine();
            ParseInput(input, ref dict, ref exit);
        }
    }

    private static void ParseInput(string input, ref Dictionary<string, float> dict, ref bool exit)
    {
        string[] tokens = input.Split(' ');

        if (input.Length == 0)
            return;

        switch (tokens[0])
        {
            case "exit":

                exit = true;
                break;

            case "delete":

                if (tokens.Length < 2)
                {
                    Console.Write("Invalid input! \n$ ");
                    break;
                }

                dict.Remove(tokens[1]);
                Console.Write("$ ");

                break;

            case "see":

                try
                {
                    Console.Write("dict[\"{0}\"] = {1} \n$ ", tokens[1], dict[tokens[1]]);
                }
                catch
                {
                    Console.Write("Invalid key! \n$ ");
                    break;
                }

                break;

            case "print":

                for (int i = 0; i < dict.GetSize(); i++)
                {
                    string temp = dict.GetKey(i);
                    Console.WriteLine("dict[\"{0}\"] = {1}", temp, dict[temp]);
                }
                Console.Write("$ ");
                break;

            case "set":

                if (tokens.Length < 3)
                {
                    Console.Write("Invalid input! \n$ ");
                    break;
                }

                try
                {
                    float val = float.Parse(tokens[2],
                                System.Globalization.CultureInfo.InvariantCulture);
                    dict[tokens[1]] = val;
                    Console.Write("$ ");
                }
                catch
                {
                    Console.Write("Invalid unput! \n$ ");
                }


                break;

            case "clear":

                Console.Clear();
                Console.Write("$ ");
                break;

            default:

                Console.Write("Invalid input! \n$ ");
                break;
        }
    }
        private static void PrintInstructions()
    {
        Console.WriteLine("Available commands (go to instruction for more details): ");
        Console.WriteLine("set <key> <value>");
        Console.WriteLine("see <key>");
        Console.WriteLine("delete <key>");
        Console.WriteLine("print");
        Console.WriteLine("clear");
        Console.WriteLine("exit\n");
    }
}