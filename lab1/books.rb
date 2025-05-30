# Day 1 Task:
# - Assume we have Inventory
# - Inventory has many books
# - Each book has title, auther and ISBN
# - The inventory should be able to 
# 	- List books
# 	- Add new book
# 	- Remove book by ISBN
# - The program should keep books in a file
# Bonus:
# 	- Sorting books by ISBN
# 	- Search books by:
# 		- Title
# 		- Auther
# 		- ISBN
# 	- Increase books count if book is inserted twice (have same ISBN) and update the title and auther if changed
# 	- Display message if the input is empty or incorrect

class Inventory
  attr_reader :title, :author, :isbn, :count # can be changed from outside

  def initialize(title, author, isbn)
    @title = title
    @author = author
    @isbn = isbn
    @count = 0
  end

  def add_to_list
    books = File.readlines("inventory.txt") #array of all books
    updated = false
    for book in books 
        books.delete(book)
        details = book.split
        if details[-2].to_i == self.isbn.to_i #book already exists 
            details[-1] = (details[-1].to_i + 1).to_s  #increase count

            #update the title and author if changed
            if details[0] != self.title
                details[0] =  self.title
            end

            if details[1] != self.author
                details[1] =  self.author
            end

            books << details.join(" ")
            File.write("inventory.txt", books.join("\n"), mode: "w")
            File.write("inventory.txt", "\n", mode: "a")
            updated = true 
        end
    end 

    File.write("inventory.txt", "#{self.title} #{self.author} #{self.isbn} #{self.count}\n", mode: "a") unless updated
  end

  def self.list_books
    File.foreach("inventory.txt") { |line| puts line }
  end

  def self.remove_book(isbn)
    # book_isbn = File.foreach("inventory.txt") { |line| puts line.include?(isbn.to_s) }
    # puts book_isbn.to_i == isbn 
    # if book_isbn.to_i == isbn 
    #     puts "deleted"
    # end
    # books = File.read("inventory.txt").split
    books = File.readlines("inventory.txt") #array of all books
    # books.each { |book| book.split[-1] } #isbn
    for book in books 
        if book.split[-2].to_i == isbn
            books.delete(book)
            break
        end
    end 
    # puts books
    File.write("inventory.txt", books.join("\n"), mode: "w")
  end

  def self.search_by_ISBN(isbn)
    books = File.readlines("inventory.txt") #array of all books
    for book in books 
        details = book.split
        if details[-2].to_i == isbn #book already exists 
            puts "#{book} \n"
        end
    end
  end

  def self.search_by_title(title)
    books = File.readlines("inventory.txt") #array of all books
    for book in books 
        details = book.split
        if details[0] == title 
            puts "#{book} \n"
        end
    end
  end

  def self.search_by_author(author)
    books = File.readlines("inventory.txt") #array of all books
    for book in books 
        details = book.split
        if details[1] == author  
            puts "#{book} \n"
        end
    end
  end

end

while true
    puts "Enter:\n1 to add new book\n2 to list books\n3 to remove a book\n4 to search by ISBN\n5 to search by Title\n6 to search by Author\n"
    op = gets.chomp
    case op
    when "1"
        puts "\nEnter title"
        name = gets.chomp
        puts "\nEnter author"
        author = gets.chomp
        puts "\nEnter ISBN"
        isbn = gets.chomp

        book = Inventory.new name,author,isbn
        book.add_to_list
    when "2"
        Inventory.list_books
    when "3"
        puts "\nEnter ISBN of book "
        isbn = gets.chomp.to_i
        Inventory.remove_book(isbn)
    when "4"
        puts "\nSearch by ISBN\nEnter ISBN "
        isbn = gets.chomp.to_i
        Inventory.search_by_ISBN(isbn)
    when "5"
        puts "\nSearch by Title\nEnter title "
        title = gets.chomp
        Inventory.search_by_title(title)
    when "6"
        puts "\nSearch by Author\nEnter Author "
        author = gets.chomp
        Inventory.search_by_author(author)
    else
        puts "\nInvalid option"
    end
end

# book1 = Inventory.new 'All the bright places', 'XYZ', 1234
# book2 = Inventory.new 'A good girls guide to murder', 'ABC', 5678
# book1.add_to_list
# book2.add_to_list

# Inventory.list_books
# Inventory.remove_book(1234)