class Dog 
  attr_accessor :name, :breed, :id
  def initialize(arguments)
    arguments.each {|key, value| self.send(("#{key}="), value)}
  end
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs 
      (id INTEGER PRIMARY KEY, 
      name TEXT, 
      breed TEXT); 
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<-SQL
      DROP TABLE dogs;
    SQL
    DB[:conn].execute(sql)
  end
  
  def save
    sql = <<-SQL
      INSERT INTO dogs
      (name, breed)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
    return self
  end
  
  def self.create(attribute_hash)
    pup = Dog.new(attribute_hash)
    pup.save
    pup
  end
  
  def self.find_by_id(idx)
    sql = <<-SQL
      SELECT * FROM dogs
      WHERE id = ?
    SQL
    
    DB[:conn].execute(sql, idx).map do |row|
      self.new_from_db(row)
    end.first
  end
  
  def self.find_or_create_by(name:, breed:)
    sql = <<-SQL
      SELECT * FROM dogs
      WHERE name = ? AND breed = ?
    SQL
    
  end
    
  def self.new_from_db(row)
    hash = {:id => row[0], :name => row[1], :breed => row[2]}
    self.new(hash)
  end

end