class CandidateMailer < ApplicationMailer
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper

  default from: ENV.fetch('HR_FROM_EMAIL', 'hr@example.com')

  SELECTION_TEMPLATE = <<~TEXT.freeze
    Dear %{name},

    We are pleased to inform you that you have been selected for the position of %{position}.

    Please reply to this email to confirm your acceptance.

    Best regards,
    HR Team
  TEXT

  REJECTION_TEMPLATE = <<~TEXT.freeze
    Dear %{name},

    Thank you for applying for the position of %{position}.

    We regret to inform you that we have decided to move forward with other candidates.

    Best regards,
    HR Team
  TEXT

  def response_email(candidate_email:, candidate_name:, position:, status:)
    @name = candidate_name
    @position = position

    body_text = if status == "selected"
      SELECTION_TEMPLATE % { name: @name, position: @position }
    else
      REJECTION_TEMPLATE % { name: @name, position: @position }
    end

    mail(to: candidate_email, subject: email_subject(status, position)) do |format|
      format.text { render plain: body_text }
      format.html { render html: simple_format(body_text).html_safe }
    end
  end

  private

  def email_subject(status, position)
    status == "selected" ? "Selection for #{position}" : "Application status for #{position}"
  end
end
