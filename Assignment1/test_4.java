// Java code to illustrate set() 
  
import java.io.*; 
import java.util.*; 
  
public class AbstractSequentialListDemo { 
    public static void main(String args[]) 
    { 
        // Creating an empty AbstractSequentialList 
        AbstractSequentialList<String> list 
            = new LinkedList<String>(); 
  
        // Use add() method to add elements in the list 
        list.add("Geeks"); 
        list.add("for"); 
        list.add("Geeks"); 
        list.add("10"); 
        list.add("20"); 
  
        // Displaying the linkedlist 
        System.out.println("AbstractSequentialList:"
                           + list); 
  
        // Using set() method to replace Geeks with GFG 
        System.out.println("The Object that is replaced is: "
                           + list.set(2, "GFG")); 
  
        // Using set() method to replace 20 with 50 
        System.out.println("The Object that is replaced is: "
                           + list.set(4, "50")); 
  
        // Displaying the modified linkedlist 
        System.out.println("The new AbstractSequentialList is:"
                           + list); 
    } 
} 