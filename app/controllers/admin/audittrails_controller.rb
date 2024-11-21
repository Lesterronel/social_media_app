module Admin
  class AudittrailsController < ApplicationController
    before_action :set_audittrail, only: %i[ show edit update destroy ]

    # GET /audittrails or /audittrails.json
    def index
      @audittrails = Audittrail.all
    end

    # GET /audittrails/1 or /audittrails/1.json
    def show
    end

    # GET /audittrails/new
    def new
      @audittrail = Audittrail.new
    end

    # GET /audittrails/1/edit
    def edit
    end

    # POST /audittrails or /audittrails.json
    def create
      @audittrail = Audittrail.new(audittrail_params)

      respond_to do |format|
        if @audittrail.save
          format.html { redirect_to @audittrail, notice: "Audittrail was successfully created." }
          format.json { render :show, status: :created, location: @audittrail }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @audittrail.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /audittrails/1 or /audittrails/1.json
    def update
      respond_to do |format|
        if @audittrail.update(audittrail_params)
          format.html { redirect_to @audittrail, notice: "Audittrail was successfully updated." }
          format.json { render :show, status: :ok, location: @audittrail }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @audittrail.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /audittrails/1 or /audittrails/1.json
    def destroy
      @audittrail.destroy!

      respond_to do |format|
        format.html { redirect_to audittrails_path, status: :see_other, notice: "Audittrail was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_audittrail
        @audittrail = Audittrail.find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
      def audittrail_params
        params.expect(audittrail: [ :module, :event_type, :current_data, :old_data, :data_differences, :ip_address, :modified_by_email, :modified_by_name ])
      end
  end
end