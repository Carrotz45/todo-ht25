require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'



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
end




