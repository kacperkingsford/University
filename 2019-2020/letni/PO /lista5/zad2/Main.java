class Main
{
    public static void main(String[] args) 
    {
     //testy : 
        Node n1 = new Node('+', new Leaf(2), new Leaf(3));
        System.out.println(n1.oblicz());
        Leaf_x l1 = new Leaf_x("x");
        l1.addVariable("x", 6);
        System.out.println(l1.oblicz());
        Node n2 = new Node('*',n1, l1);
        System.out.println(n2.oblicz());
    }
}