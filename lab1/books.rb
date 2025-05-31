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
  attr_reader :title, :author, :isbn, :count # can be read from outside

  def initialize(title, author, isbn)
    @title = title
    @author = author
    @isbn = isbn
    @count = 1
  end

  def add_to_list
    books = File.readlines("inventory.txt") # Array of all books
    updated = false

    books.map! { |book|
        details = book.split
        if details[-2].to_i == self.isbn.to_i  # If book already exists
            details[-1] = (details[-1].to_i + 1).to_s  # Increase count

            # Update the title and author if changed
            details[0] = self.title if details[0] != self.title
            details[1] = self.author if details[1] != self.author

            updated = true
        end
        details.join(" ")
    }

    books << "#{self.title} #{self.author} #{self.isbn} #{self.count}" unless updated
    books.sort_by! { |book| book.split[-2].to_i } # Sorting books by ISBN
    File.write("inventory.txt", books.join("\n"))
  end

  def self.list_books
    puts "\nInventory:"
    # File.foreach("inventory.txt") { |line| puts line }
    File.foreach("inventory.txt") { |line|
        details = line.split
        puts "Title: #{details[0]}\nAuthor: #{details[1]}\nISBN: #{details[2]}\nCount: #{details[3]}\n\n"
    }

  end

  def self.remove_book(isbn)
    books = File.readlines("inventory.txt")
    found = false

    for book in books 
        if book.split[-2].to_i == isbn
            books.delete(book)
            found = true
            break
        end
    end 

    # puts books
    puts "Not found." unless found
    File.write("inventory.txt", books.join("\n"), mode: "w") unless !found
  end

  def self.search_by_ISBN(isbn)
    books = File.readlines("inventory.txt") 
    found = false

    for book in books 
        details = book.split
        if details[-2].to_i == isbn 
            # puts book
            puts "Title: #{details[0]}\nAuthor: #{details[1]}\nISBN: #{details[2]}\nCount: #{details[3]}\n\n"
            found = true
        end
    end

    puts "Not found." unless found
  end

  def self.search_by_title(title)
    books = File.readlines("inventory.txt") 
    found = false

    for book in books 
        details = book.split
        if details[0] == title 
            # puts book
            puts "Title: #{details[0]}\nAuthor: #{details[1]}\nISBN: #{details[2]}\nCount: #{details[3]}\n\n"
            found = true
        end
    end

    puts "Not found." unless found
  end

  def self.search_by_author(author)
    books = File.readlines("inventory.txt") 
    found = false

    for book in books 
        details = book.split
        if details[1] == author  
            # puts book
            puts "Title: #{details[0]}\nAuthor: #{details[1]}\nISBN: #{details[2]}\nCount: #{details[3]}\n\n"
            found = true
        end
    end

    puts "Not found." unless found
  end

end

while true
    puts "\nEnter:\n1 to add new book\n2 to list books\n3 to remove a book\n4 to search by ISBN\n5 to search by Title\n6 to search by Author\n"
    op = gets.chomp

    case op
    when "1"
        puts "\nEnter title"
        name = gets.chomp

        puts "\nEnter author"
        author = gets.chomp

        puts "\nEnter ISBN"
        isbn = gets.chomp

        if name.empty? || author.empty? || isbn.empty? 
            puts "\nInvalid input. Title, Author, and ISBN cannot be empty"
        else
            book = Inventory.new name,author,isbn
            book.add_to_list
        end
    when "2"
        Inventory.list_books
    when "3"
        puts "\nEnter ISBN of book: "
        isbn = gets.chomp

        if isbn.empty?
            puts "\nInvalid ISBN! Please enter a valid number."
        else
            Inventory.remove_book(isbn.to_i)
        end
    when "4"
        puts "\nSearch by ISBN\nEnter ISBN: "
        isbn = gets.chomp

        if isbn.empty?
            puts "\nInvalid ISBN! Please enter a valid number."
        else
            Inventory.search_by_ISBN(isbn.to_i)
        end
    when "5"
        puts "\nSearch by Title\nEnter title: "
        title = gets.chomp

        if title.empty?
            puts "\nInvalid title! Please enter a valid book title."
        else
            Inventory.search_by_title(title)
        end
    when "6"
        puts "\nSearch by Author\nEnter Author: "
        author = gets.chomp

        if author.empty?
            puts "\nInvalid author name! Please enter a valid author name."
        else
            Inventory.search_by_author(author)
        end
    else
        puts "\nInvalid option"
    end
end

# book1 = Inventory.new 'All the bright places', 'XYZ', 12345678
# book2 = Inventory.new 'A good girls guide to murder', 'ABC', 56781234
# book1.add_to_list
# book2.add_to_list

# Inventory.list_books
# Inventory.remove_book(1234)