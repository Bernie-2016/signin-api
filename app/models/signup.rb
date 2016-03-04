class Signup < ActiveRecord::Base
  belongs_to :event

  serialize :extra_fields, JSON

  validate :validate_extra_fields

  validates :first_name, :last_name, :email, :zip, :can_text, presence: true

  def send_to_bsd!
    # Skip if email or zip is malformed.
    unless email.include?('@') && zip.try(:size) == 5
      update(posted_bsd: true)
      return
    end

    connection = BlueStateDigital::Connection.new(host: 'bernie16.cp.bsd.net', api_id: ENV['BSD_ID'], api_secret: ENV['BSD_SECRET'])

    # Construct the XML to send
    builder = ::Builder::XmlMarkup.new
    builder.instruct! :xml, version: '1.0', encoding: 'utf-8'
    xml_body = builder.api do |api|
      api.signup_form(id: ENV['BSD_SIGNUP_ID']) do |form|
        form.signup_form_field(first_name, id: 8363)
        form.signup_form_field(last_name, id: 8365)
        form.signup_form_field(email, id: 8361)
        form.signup_form_field(phone, id: 8372) unless phone.blank? || phone == '""'
        form.signup_form_field(zip, id: 8370)
        form.signup_form_field((can_text == 'Yes' ? 1 : 0), id: 8375)
        if event
          name = event.name.gsub(/[^A-Za-z]/i, '')
          if event.date
            date = event.date.strftime('%m%d%Y')
            form.source("#{name}-#{date}")
          else
            form.source(name)
          end
        end
      end
    end

    # Post it to the endpoint
    connection.perform_request_raw '/signup/process_signup', {}, 'POST', xml_body
    update(posted_bsd: true)
  end

  def answer(question)
    fields = (extra_fields || {})
    questions = fields['questions'] || []
    ans = questions.find { |a| a['question_id'] == question.id } || {}
    ans['response']
  end

  def validate_extra_fields
    return unless extra_fields

    if extra_fields.is_a?(Hash)
      extra_fields.stringify_keys!

      if extra_fields.key?('questions')
        unless extra_fields['questions'].is_a?(Array)
          errors.add(:extra_fields, 'Questions must be an array')
        end

        extra_fields['questions'].each do |question|
          unless question.keys == %w(question_id response)
            errors.add(:extra_fields, 'Improperly formatted questions array')
          end
        end
      else
        errors.add(:extra_fields, 'Data must contain `questions` field')
      end
    else
      errors.add(:extra_fields, 'Data must be an object')
    end
  end
end
