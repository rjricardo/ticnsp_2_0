class CommissionsController < WebApplicationController
  before_action :set_commission, only: [:show, :edit, :update, :destroy, :assign_coordinator, :unassign_coordinator]

  # GET /commissions
  # GET /commissions.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: CommissionDatatable.new(view_context) }
    end
  end

  # GET /commissions/typeaheaddata.json
  def typeaheaddata
    render json: Commission.select(:id, :name), status: 200
  end

  # GET /commissions/1
  # GET /commissions/1.json
  def show
    RecentItem.create( visitor: current_user, recentable: @commission )
    @semester = ( params['semester'] == nil ? @current_semester : Semester.find( params['semester'] ) )
    @group_enrollment = GroupEnrollment.new
    @group_offering = @commission.group_offerings.find_by_semester_id( @semester.id )
  end

  # POST /commissions/1/assign_coordinator
  def assign_coordinator
    if @commission.set_mark :coordinator_commission, User.find(params[:id])
      redirect_to @commission, notice: 'Coordinator successfully assigned'
    else
      redirect_to @commission, alert: 'Could not assign coordinator'
    end
  end

  # DELETE /commissions/1/unassign_coordinator
  def unassign_coordinator
    if @commission.remove_mark :coordinator_commission, User.find(params[:id])
      redirect_to @commission, notice: 'Coordinator successfully unassigned'
    else
      redirect_to @commission, alert: 'Could not unassign coordinator'
    end
  end

  # GET /commissions/new
  def new
    @commission = Commission.new
  end

  # GET /commissions/1/edit
  def edit
  end

  # POST /commissions
  # POST /commissions.json
  def create
    @commission = Commission.new(commission_params)

    respond_to do |format|
      if @commission.save
        format.html { redirect_to @commission, notice: 'Commission was successfully created.' }
        format.json { render :show, status: :created, location: @commission }
      else
        format.html { render :new }
        format.json { render json: @commission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /commissions/1
  # PATCH/PUT /commissions/1.json
  def update
    respond_to do |format|
      if @commission.update(commission_params)
        format.html { redirect_to @commission, notice: 'Commission was successfully updated.' }
        format.json { render :show, status: :ok, location: @commission }
      else
        format.html { render :edit }
        format.json { render json: @commission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commissions/1
  # DELETE /commissions/1.json
  def destroy
    @commission.destroy
    respond_to do |format|
      format.html { redirect_to commissions_url, notice: 'Commission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_commission
      @commission = Commission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def commission_params
      params.require(:commission).permit(:name, :description, :image)
    end
end
