describe Signup do
  it { is_expected.to belong_to(:event) }
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:zip) }
  it { is_expected.to validate_presence_of(:can_text) }

  describe '#send_to_bsd!' do
    let!(:signup) { create(:signup) }

    before do
      ENV['BSD_ID'] = 'EventSignups'
      ENV['BSD_SECRET'] = 'secret'
      ENV['SIGNUP_ID'] = '1'
    end

    subject { signup.send_to_bsd! }

    context 'when parameters are valid' do
      before { stub_request(:post, %r{https:\/\/bernie16.cp.bsd.net\/page\/api\/signup\/process_signup}).to_return(status: 200, body: '', headers: {}) }

      it 'updates the signup bsd flag' do
        expect { subject }.to change { signup.posted_bsd }.from(false).to(true)
      end
    end

    context 'when parameters are invalid' do
      before { stub_request(:post, %r{https:\/\/bernie16.cp.bsd.net\/page\/api\/signup\/process_signup}).to_return(status: 400, body: '', headers: {}) }

      it 'updates the signup bsd flag' do
        expect { subject }.to raise_error(Faraday::ClientError)
      end
    end

    context 'when email is malformed' do
      let!(:signup) { create(:signup, email: 'nonsense') }

      it 'updates the signup bsd flag' do
        expect { subject }.to change { signup.posted_bsd }.from(false).to(true)
      end
    end
  end
end
