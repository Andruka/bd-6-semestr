import java.util.List;
import redis.clients.jedis.Jedis; 
import java.sql.*;
import java.util.Scanner;
import java.util.HashMap;
import java.util.Map;



public class RedisListJava { 

   public static void main(String[] args) { 
      //подключение к redis 
      Jedis jedis = new Jedis("localhost"); 
      System.out.println("Connection to redis sucessfully");
      //подключение к postgresql
      int a; 
      String zapr;
      String key = "lab6";
      String string="";
      String buf="";
      Scanner sc = new Scanner(System.in);
      Scanner zap = new Scanner(System.in);
      Connection c = null;
       Statement stmt = null;
       try {
         Class.forName("org.postgresql.Driver") ;
         c = DriverManager
            .getConnection("jdbc:postgresql://localhost/lab6",
            "kuzminov" , "12345");
         System.out.println("Connection to postgresql sucessfully") ;



	 while(true){
	 System.out.println("1. Ввести запрос\n2. Очистить кэш\n0. Выход\n");
	 a = sc.nextInt();  
	   switch(a)
           {
             case 1 :
              System.out.print("Ваш запрос:");
              zapr = zap.nextLine(); 
	      List<String> list =jedis.hmget(key, zapr);
	      if(list.get(0)==null){
	          System.out.println("Новый запрос");
		  c.setAutoCommit(true);
	          stmt = c.createStatement() ;
                  ResultSet rs = stmt.executeQuery( zapr );
		  String cursorName = rs.getCursorName();
                  int columns = rs.getMetaData().getColumnCount();  
                  for (int i = 1; i <= columns; i++){
		      buf=rs.getMetaData().getColumnLabel(i);
		      string = string+buf+"\t";
		      System.out.print(buf + "\t");
                  }
                  string=string+"\n";
                  System.out.println();
                  while(rs.next()){            
                    for (int i = 1; i <= columns; i++){
		        buf=rs.getString(i);
		        string = string+buf+"\t";
                        System.out.print(buf + "\t");
                    }
	          string=string+"\n";
                  System.out.println();
                  }
	          Map<String, String> map = new HashMap<>();
                  map.put(zapr, string);
                  jedis.hmset(key, map);
	      }
	      else{
		  System.out.println("Запрос из кэша");
	          list =jedis.hmget(key, zapr);
	          System.out.println(list.get(0));
	      }
              break;
             case 2 :
              jedis.del(key);
	      System.out.println("Кэш удалён");
   	      break;
	     case 0 :
              System.exit(0);
   	      break;
             default :
              System.out.println("Неверная ввод");
           }
	 }

       } catch ( Exception e ) {
         System.err.println( e.getClass() .getName()+": "+ e.getMessage() );
         System.exit(0) ;
       }
 
   } 
} 

