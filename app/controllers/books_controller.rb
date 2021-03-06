class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:show_image]
  before_filter :usercheck, except: [:show, :show_image, :show_bookfile]
  
  skip_before_filter :verify_authenticity_token
  
  layout 'backend'

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
  end

  # GET /books/1
  # GET /books/1.json
  def show_image
    @book = Book.find(params[:id])
      send_data(@book.cover,type: @book.Image_Format, filename: @book.Image_Filename, disposition: 'inline')
  end
  
  def show_bookfile
    @book = Book.find(params[:id])
   # @userid = Order.where(':bookId => @book.id AND :userId => current_user.id')
    if (current_user.userId == 3 || @book.authorId == current_user.id)
        send_data(@book.bookfile,type: @book.Book_Format, filename: @book.Book_Filename)
    end
  end
  
  
  def show
    @book = Book.find(params[:id])
    @author = User.find(@book.authorId)
  end
  

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    
    @book = Book.new(book_params)
    
    @book.authorId = current_user.id
    
    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
  

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:name, :authorId, :category, :description, :price, :publishedDate, :status, :condition, :cover, :bookfile, :file, :filemain)
    end
    
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end
    
end
