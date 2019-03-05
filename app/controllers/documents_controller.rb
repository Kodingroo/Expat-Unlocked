class DocumentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  skip_after_action :verify_authorized, only: [:index, :show]

  def index
    @documents = policy_scope(Document).order(created_at: :desc)
  end

  def show
    @document = Document.find(params[:id])
  end

  # def new
  #   @document = Document.new
  #   authorize @document
  # end

  def create
    @document = Document.new(document_params)
    authorize @document

    if @document.save
      redirect_to @document, notice: 'Document was successfully created.'
    else
      render :new
    end
  end

  def document_params
    params.require(:document).permit(:jp_name, :company_name, :payment_type, :description)
  end
end
