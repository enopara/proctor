class ResponsesController < ApplicationController
  def create
    @survey = Survey.find(params[:survey_id])

    # Normalize role from incoming params (top-level, not nested)
    role = params[:role].to_s.strip.downcase.presence

    # Build the response tied explicitly to this survey
    @response = @survey.responses.new(
      response_params.merge(role: role)
    )

    respond_to do |format|
      if @response.save
        format.html { redirect_to surveys_path, notice: 'Response was successfully recorded.' }
        format.json { render json: { success: true }, status: :created }
      else
        format.html { redirect_to take_survey_path(@survey), alert: 'There was an error recording your response.' }
        format.json { render json: { error: @response.errors.full_messages.join(', ') }, status: :unprocessable_entity }
      end
    end
  end

  private

  def response_params
    # don't let the client send `role` directly
    # We merge it ourselves above after normalizing
    # We ALSO don't let them sneak in some other survey_id. We trust @survey.
    params.require(:response).permit(:question_id, :value)
  end
end
