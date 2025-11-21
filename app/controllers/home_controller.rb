class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:send_email]  # for API-style testing; keep CSRF in real app

  def index
    # renders index
  end

  def send_email
    name = params[:candidate_name].to_s.strip
    email = params[:candidate_email].to_s.strip
    position = params[:position].to_s.strip
    status = params[:status].to_s.strip

    # basic server-side validation
    if name.empty? || email.empty? || position.empty?
      render json: { error: 'Missing fields' }, status: :bad_request and return
    end

    begin
      CandidateMailer.response_email(
        candidate_email: email,
        candidate_name: name,
        position: position,
        status: status
      ).deliver_now

      # respond with JSON for AJAX or redirect with flash
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Email sent successfully' }
        format.json { render json: { message: 'Email sent' } }
      end
    rescue => e
      Rails.logger.error("Email send failed: #{e.message}")
      respond_to do |format|
        format.html { redirect_to root_path, alert: 'Failed to send email' }
        format.json { render json: { error: 'Failed to send' }, status: :internal_server_error }
      end
    end
  end
end
