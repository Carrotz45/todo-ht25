require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'
require 'BCrypt'



# Funktion för att prata med databasen
# Exempel på användning: db.execute('SELECT * FROM fruits')
# def db
#   return @db if @db

#   @db = SQLite3::Database.new(DB_PATH)
#   @db.results_as_hash = true

#   return @db
# end

# Routen /

get('/') do

  db = SQLite3::Database.new("db/todos.db")
  db.results_as_hash = true
  @todo_arr = db.execute("SELECT * FROM todos")
  slim(:index)

end

post('/') do
  query_name = params[:new_todo_name]
  query_desc = params[:new_todo_desc]



  db = SQLite3::Database.new("db/todos.db")

  db.execute("INSERT INTO todos (name, description) VALUES(?,?)", [query_name, query_desc])
  redirect('/')
end

post('/:id/delete') do
  delete_this = params[:id]

  db = SQLite3::Database.new("db/todos.db")

  db.execute("DELETE FROM todos WHERE id=?", [delete_this])
  redirect('/')

end

get('/:id/edit') do
  id = params[:id].to_i
  db = SQLite3::Database.new('db/todos.db')
  db.results_as_hash = true
  @selected_todos = db.execute("SELECT * FROM todos WHERE id = ?", [id]).first
  
  slim(:edit)

end

post('/:id/update') do
  db = SQLite3::Database.new('db/todos.db')

  id = params[:id].to_i
  name = params[:name]
  description = params[:description]

  db.execute("UPDATE todos SET name=?, description=? WHERE id=?",[name, description, id])

  redirect('/')
end

get('/register') do
  slim(:register)
end

post('/register') do
  db = SQLite3::Database.new('db/todos.db')
  username = params["username"]
  password = params["password"]
  password_confirmation = params["confirm_password"]


  result = db.execute("SELECT id FROM users WHERE username=?", username)

  if result.empty?
    if password == password_confirmation
      password_digest = BCrypt::Password.create(password)
      p password_digest
      db.execute("INSERT INTO users(username, pwd_digest) VALUES (?,?)", [username, password_digest])
      redirect('/')
    else
      #error not matching
      p "not matcing"
      redirect('/error')
    end
  else
    #error results not filled out
    p "user exists"
    redirect('/error')
  end

end

get ('/login') do

  slim(:login)
end

post('/login') do
  username = params["username"]
  password = params["password"]

  
end


  




