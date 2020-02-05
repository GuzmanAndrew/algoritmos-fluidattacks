/**
 * Run:
 * 1. Step One: javac Staircase.java, for compiler
 * 2. Step Two: java Staircase, for run
 */

public class Staircase {
    public static void main(String[] args) {

        System.out.println(String.format("%6s", "#"));
        System.out.println(String.format("%5s", "#") + "#");
        System.out.println(String.format("%4s", "#") + "##");
        System.out.println(String.format("%3s", "#") + "###");
        System.out.println(String.format("%2s", "#") + "####");
        System.out.println(String.format("%1s", "#") + "#####");

    }
}

/**
 * Out:
     #
    ##
   ###
  ####
 #####
######
 */