namespace Grammars
{   
    // Klasa ContextFreeGrammar reprezentująca gramatykę bezkontekstową, 
    // czyli zbiór terminali, nieterminali, zasad wyprowadzania oraz
    // symbolu startowego.
    public class ContextFreeGrammar
    {
        // Tablica zasad wyprowadzania.
        private ProductionRule[] productionRules;
        // Symbol startowy.
        private char startingSymbol;
        // Obiekt generujący liczby pseudolosowe.
        System.Random randomizer;

        // Konstruktor.
        public ContextFreeGrammar(char startingSymbol, ProductionRule[] rules)
        {
            randomizer = new System.Random();

            this.startingSymbol = startingSymbol;
            this.productionRules = rules;
        }

        // Predykat sprawdzający, czy słowo zawiera nieterminale.
        private static bool ContainsNonTerminals(string word)
        {
            foreach (var symbol in word)
                if (IsNonTerminal(symbol))
                    return true;
            return false;
        }

        // Predykat sprawdzający, czy dany symbol jest nieterminalem.
        private static bool IsNonTerminal(char symbol)
        {
            return (symbol >= 'A' && symbol <= 'Z');
        }

        // Procedura losująca zasadę wyprowadzania, która zostanie zastosowana
        // przy generowaniu nowego losowego wyrazu.
        private ProductionRule RandomProductionRule(char symbol)
        {
            ProductionRule[] rulesTempArray = new ProductionRule[productionRules.Length];
            
            int i = 0;

            // Tworzenie tymczasowej tablicy, która zawiera zasady
            // wyprowadzania dla zadanego symbolu.
            foreach (var productionRule in productionRules)
                if (productionRule.NonTerminal == symbol)
                    rulesTempArray[i++] = productionRule;

            // Jeżeli nie znaleziono zasady wyprowadzania dla danego
            // nieterminalu, to zwracany jest błąd.
            if (i == 0)
                throw new System.Exception("Error! Grammar is not correct!");

            // Zwracanie losowej zasady z podanych.
            return rulesTempArray[randomizer.Next(0, i)];
        }

        // Metoda generująca losowe słowo zgodne z zasadami
        // danej gramatyki bezkontekstowej.
        public string GenerateWord()
        {
            // Każde wyprowadzane słowo zaczyna się od symbolu startowego.
            string word = this.startingSymbol.ToString();

            // Zastępowanie wszystkich nieterminali przy
            // uzyciu zasad wyprowadzania.
            while (ContainsNonTerminals(word))
            {
                for (int i = 0; i < word.Length; i++)
                {
                    if (IsNonTerminal(word[i]))
                    {
                        int beginningLength = i;
                        int endLength = word.Length - (i + 1);

                        string beginning = word.Substring(0, beginningLength);
                        string end = word.Substring((i + 1), endLength);
                        string substitution = RandomProductionRule(word[i]).Production;
          
                        word = beginning + substitution + end;

                        break;
                    }
                }
            }

            return word;
        }
    }

    // Klasa reprezentująca zasadę wyprowadzania.
    public class ProductionRule
    {
        // Symbol, z którego wyprowadzamy.
        private char nonTerminal;
        // Wyprowadzane słowo.
        private string production;

        // Właściwość pozwalająca na dostęp do symbolu „nonTerminal”.
        public char NonTerminal
        {
            get {return nonTerminal;}
        }

        // Właściwość pozwalająca na dostęp do wyprowadzanego słowa.
        public string Production
        {
            get {return production;}
        }

        // Konstruktor tworzący zasadę wyprowadzania z symbolu oraz słowa.
        public ProductionRule(char nonTerminal, string production)
        {
            this.nonTerminal = nonTerminal;
            this.production = production;
        }
    }
}
