describe Api::V1::SignupsController do
  let!(:user) { create(:user, :admin, email: 'bernie@berniesanders.com') }
  let!(:event) { create :event }

  describe '#create' do
    let(:signup) { build(:signup) }
    let(:signups) { { '0' => signup.attributes.to_options } }

    subject { post :create, signups: signups }

    context 'valid params' do
      it 'creates the signup' do
        expect { subject }.to change { Signup.count }.by(1)
      end
    end

    context 'signup exists' do
      let!(:existing_signup) { create(:signup, email: signup.email, event_id: signup.event_id) }

      it 'returns 200' do
        expect(subject).to have_http_status(200)
      end

      it 'does not create the signup' do
        expect { subject }.to change { Signup.count }.by(0)
      end
    end

    context 'missing param' do
      let(:signup) { build(:signup, first_name: nil) }

      it 'does not create the signup' do
        expect { subject }.to change { Signup.count }.by(0)
      end

      it 'returns 422' do
        expect(subject).to have_http_status(422)
      end
    end

    context 'extra_fields' do
      let!(:event) { create :event }

      context 'valid' do
        let(:signup) { build(:signup, extra_fields: [{ questions: [question_id: '', response: ''] }].to_json) }

        it 'returns 200 as normal' do
          expect(subject).to have_http_status(200)
        end
      end

      context 'invalid' do
        context 'extra fields is not an object' do
          let(:signup) { build(:signup, extra_fields: 'hi') }

          it 'returns 422' do
            expect(subject).to have_http_status(422)
          end
        end

        context 'no `questions` key' do
          let(:signup) { build(:signup, extra_fields: [{ random_key: [] }].to_json) }

          it 'returns 422' do
            expect(subject).to have_http_status(422)
          end
        end

        context '`questions` key is not an array' do
          let(:signup) { build(:signup, extra_fields: [{ questions: {} }].to_json) }

          it 'returns 422' do
            expect(subject).to have_http_status(422)
          end
        end

        context 'nested `questions` array hash that does not contain question_id and response' do
          let(:signup) { build(:signup, extra_fields: [{ questions: [not_question_id: '', not_response: ''] }].to_json) }

          it 'returns 422' do
            expect(subject).to have_http_status(422)
          end
        end
      end
    end
  end
end
