require "sqlite3"
=begin
Part I

#1 undestanding how SQLite is working
SELECT
INSERT
UPDATE
DESTROY

#2 write user model

Part II
=end

$db_filename = "db.sql"
$tablename   = "users"

class ConnectionSqlite

    def new
        @db = nil
    end

    def get_connection
        if @db == nil
        @db  = SQLite3::Database.new ($db_filename)
        createdb
        end
        @db 
    end

    def createdb

    rows = self.get_connection().execute <<-SQL
            CREATE TABLE IF NOT EXISTS #{$tablename} (
            id INTEGER PRIMARY KEY,
            firstname varchar(30),
            lastname varchar(30),
            age int,
            password varchar(30),
            email varchar(30)
            );
            SQL
    end

    def execute (query)
    self.get_connection().execute(query)
    end 

end



class User

    attr_accessor :id, :firstname, :lastname, :age, :password, :email

    def initialize (array)
        @id        = array[0]
        @firstname = array[1]
        @lastname  = array[2]
        @age       = array[3]
        @password  = array[4]
        @email     = array[5]

    end

    def to_hash
        {id: @id, firstname: @firstname, lastname: @lastname, age: @age, password: @password, email: @email}
    end

    def inspect
        %Q|<User id: #{ @id}, firstname: "#{@firstname}", lastname "#{@lastname}", age: "#{@age}", password: "#{@password}", email: "#{@email}">|
    end
    
    def self.create(user_info)        
        query= <<-REQUEST
        INSERT INTO #{$tablename}(firstname, lastname, age, password, email) VALUES("#{user_info[:firstname]}",
        "#{user_info [:lastname]}",
        "#{user_info [:age]}",
        "#{user_info [:password]}",
        "#{user_info [:email]}");
         
        REQUEST
       
        ConnectionSqlite.new.execute(query)

       
    end

    def self.get(user_id)
        query= <<-REQUEST
        SELECT * FROM #{$tablename} WHERE id = #{user_id};        
        REQUEST
        
        rows = ConnectionSqlite.new.execute(query)
        if rows.any?
            User.new(rows[0])
        else
            nil
        end

    end

    def self.all
        query= <<-REQUEST
        SELECT * FROM #{$tablename};        
        REQUEST
        
        rows = ConnectionSqlite.new.execute(query)
        if  rows.any?
            rows.collect do |row|
            User.new(row)
            end
        else
            []
        end
    end

    def self.update(user_id, attribute, value)
        query= <<-REQUEST
        UPDATE #{$tablename}
            SET #{attribute.to_s} = '#{value}'
            WHERE id = #{user_id};        
        REQUEST
       puts query
        ConnectionSqlite.new.execute(query)
       
    end

    def self.destroy(user_id)
        query= <<-REQUEST
        DELETE FROM #{$tablename}
            WHERE id = #{user_id};        
        REQUEST
       puts query
        ConnectionSqlite.new.execute(query)

    end

end

class Hash 
    def exept(*keys)
        item = self.dup
        keys.each{|key| item.delete(key)}
        item
    end
end
def _main()
    #p User.create(firstname:"Oksana", lastname:"Stupakova", age:50, password:"toto", email:"zorya@gmail.com")
    p User.create(firstname:"Oksana1", lastname:"Stupakova", age:50, password:"zorya ", email:"zorya@gmail.com")
    #p User.update(1, :password, "zorya")
    #p User.get(1)
    #p User.get(2)
    #p User.get(3)
    #p User.get(4)
    #p User.get(5)
    #p User.destroy(1)
    #p User.get(1)
    


end
#_main()