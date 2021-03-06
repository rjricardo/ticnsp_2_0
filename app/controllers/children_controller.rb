class ChildrenController < WebApplicationController
  before_action :set_child, only: [:show, :edit, :update, :destroy, :assign_to_tutor, :unassign_from_tutor, :enroll_in_workshop, :enroll_in_lecture, :enroll_in_shepperding, :unenroll_from_workshop, :unenroll_from_lecture, :unenroll_from_shepperding]

  # GET /children
  # GET /children.json
  def index
    # @children = Child.all
    respond_to do |format|
      format.html
      format.json { render json: ChildDatatable.new(view_context) }
    end
  end

  # GET /children/typeaheaddata.json
  def typeaheaddata
    render json: Child.select(:id, :name, :lastname).map { |c| { id: c.id, name: "#{c.name} #{c.lastname}"} }, status: 200
  end

  # GET /children/1
  # GET /children/1.json
  def show
    RecentItem.create( visitor: current_user, recentable: @child )
    @semester = ( params['semester'] == nil ? @current_semester : Semester.find( params['semester'] ) )
    @notifications = Notification.where( notifiable: @child )
    @groups = GroupOffering.where( id: @child.group_enrollments.pluck( :group_offering_id ) ).where( semester: @semester )
  end

  # POST /children/1/assign_to_tutor
  def assign_to_tutor
    tutor = User.find(params[:tutor_id])
    tutor.mark_as_responsability @child
    redirect_to @child, notice: 'Niño ha sido asignado a tutor.'
  end

  # DELETE /children/1/unassign_from_tutor
  def unassign_from_tutor
    tutor = User.find(params[:tutor_id])
    tutor.remove_mark :responsability, @child
    redirect_to @child, alert: 'Niño ha sido desasignado.'
  end

  # POST /children/1/enroll_in_workshop
  def enroll_in_workshop
    workshop = Workshop.find(params[:workshop_id])
    workshop.mark_as_enrolled_workshop @child
    redirect_to @child, notice: 'Niño inscrito exitosamente.'
  end

  # POST /children/1/enroll_in_lecture
  def enroll_in_lecture
    lecture = Lecture.find(params[:lecture_id])
    lecture.mark_as_enrolled_lecture @child
    redirect_to @child, notice: 'Niño inscrito exitosamente.'
  end

  # POST /children/1/enroll_in_shepperding
  def enroll_in_shepperding
    shepperding = Shepperding.find(params[:shepperding_id])
    shepperding.mark_as_enrolled_shepperding @child
    redirect_to @child, notice: 'Niño inscrito exitosamente.'
  end

  # DELETE /children/1/enroll_from_workshop
  def unenroll_from_workshop
    workshop = Workshop.find(params[:workshop_id])
    workshop.remove_mark :enrolled_workshop, @child
    redirect_to @child, alert: 'El niño ya no está inscrito en el taller.'
  end

  # DELETE /children/1/enroll_from_lecture
  def unenroll_from_lecture
    lecture = Lecture.find(params[:lecture_id])
    lecture.remove_mark :enrolled_lecture, @child
    redirect_to @child, alert: 'El niño ya no está inscrito en la catequesis.'
  end

  # DELETE /children/1/enroll_from_shepperding
  def unenroll_from_shepperding
    shepperding = Shepperding.find(params[:shepperding_id])
    shepperding.remove_mark :enrolled_shepperding, @child
    redirect_to @child, alert: 'El niño ya no está inscrito en el acompañamiento.'
  end

  # GET /children/new
  def new
    @child = Child.new
  end

  # GET /children/1/edit
  def edit
  end

  # POST /children
  # POST /children.json
  def create
    @child = Child.new(child_params)

    respond_to do |format|
      if @child.save
        format.html { redirect_to @child, notice: 'Child was successfully created.' }
        format.json { render :show, status: :created, location: @child }
      else
        format.html { render :new }
        format.json { render json: @child.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /children/1
  # PATCH/PUT /children/1.json
  def update
    respond_to do |format|
      if @child.update(child_params)
        format.html { redirect_to @child, notice: 'Child was successfully updated.' }
        format.json { render :show, status: :ok, location: @child }
      else
        format.html { render :edit }
        format.json { render json: @child.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /children/1
  # DELETE /children/1.json
  def destroy
    @child.destroy
    respond_to do |format|
      format.html { redirect_to children_url, notice: 'Child was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_child
      @child = Child.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def child_params
      params.require(:child).permit(:name, :lastname, :gender, :birthdate, :image, :allergies, :notes)
    end
end
