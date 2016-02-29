describe Api::V1::EventsController do
  let(:role) { :user }
  let!(:user) { create(:user, role: role, email: 'bernie@berniesanders.com') }
  let!(:user_event) { create(:event, user: user) }
  let!(:other_event) { create(:event) }

  before do
    stub_request(:get, 'https://www.googleapis.com/oauth2/v1/userinfo?alt=json')
      .to_return(status: 403, body: '', headers: {})
    stub_request(:get, 'https://www.googleapis.com/oauth2/v1/userinfo?alt=json')
      .with(headers: { 'Authorization' => 'Bearer good' })
      .to_return(status: 200, body: { email: 'bernie@berniesanders.com' }.to_json, headers: {})
    stub_request(:get, 'https://www.googleapis.com/oauth2/v1/userinfo?alt=json')
      .with(headers: { 'Authorization' => 'Bearer bad' })
      .to_return(status: 403, body: '', headers: {})
  end

  describe '#index' do
    subject { get :index }

    context 'no auth token given' do
      it 'returns 403' do
        expect(subject.response_code).to eq(403)
      end
    end

    context 'bad auth token given' do
      before { request.headers['Authorization'] = 'Bearer bad' }

      it 'returns 403' do
        expect(subject.response_code).to eq(403)
      end
    end

    context 'good auth token given' do
      before { request.headers['Authorization'] = 'Bearer good' }

      context 'user has user role' do
        it 'returns only user event' do
          response = JSON.parse(subject.body)
          expect(response.length).to eq(1)
        end
      end

      context 'user has admin role' do
        let(:role) { :admin }

        it 'returns all events' do
          response = JSON.parse(subject.body)
          expect(response.length).to eq(2)
        end
      end
    end
  end

  describe '#show' do
    let(:event_id) { user_event.id }
    before { request.headers['Authorization'] = 'Bearer good' }

    subject { get :show, id: event_id }

    context 'user has user role' do
      context 'showing user event' do
        it 'returns event' do
          response = JSON.parse(subject.body)
          expect(response['name']).to eq(user_event.name)
        end
      end

      context 'showing other event' do
        let(:event_id) { other_event.id }
        it 'returns 403' do
          expect(subject).to have_http_status(403)
        end
      end
    end

    context 'user has admin role' do
      let(:role) { :admin }

      context 'showing user event' do
        it 'returns event' do
          response = JSON.parse(subject.body)
          expect(response['name']).to eq(user_event.name)
        end
      end

      context 'showing other event' do
        let(:event_id) { other_event.id }

        it 'returns event' do
          response = JSON.parse(subject.body)
          expect(response['name']).to eq(other_event.name)
        end
      end
    end
  end

  describe '#csv' do
    let(:event_id) { user_event.id }
    let!(:signups) { create_list(:signup, 25, event: user_event) }
    let!(:question) { create(:question, event: user_event) }

    before { request.headers['Authorization'] = 'Bearer good' }

    subject { get :csv, event_id: event_id }

    it 'returns csv' do
      csv_rows = subject.body.split("\n")
      expect(csv_rows.length).to eq(26)
      expect(csv_rows.first).to eq("timestamp,event,first_name,last_name,email,phone,zip,can_text,#{question.title}")
      # first_row = "#{signups.last.created_at},#{signups.last.event.name},#{signups.last.first_name},#{signups.last.last_name},#{signups.last.email},#{signups.last.phone},#{signups.last.zip},#{signups.last.can_text}"
      # expect(csv_rows[1]).to eq(first_row)
    end
  end

  describe '#create' do
    before { request.headers['Authorization'] = 'Bearer good' }

    subject { post :create, event: event }

    context 'missing params' do
      let(:event) { { date: Date.today } }

      it 'returns 422' do
        expect(subject).to have_http_status(422)
      end
    end

    context 'with all required params' do
      let(:event) { { name: 'Bernie Bake-off', slug: 'bbo', date: Date.today } }

      it 'returns 200' do
        expect(subject).to have_http_status(200)
      end

      it 'creates the event' do
        response = JSON.parse(subject.body)
        expect(response['name']).to eq('Bernie Bake-off')
      end
    end
  end

  describe '#update' do
    let(:event) { create :event, name: 'Bernie Bake-off' }

    before { request.headers['Authorization'] = 'Bearer good' }

    subject { put :update, params }

    context 'missing params' do
      let(:params) { { id: user_event.id, event: { name: nil } } }

      it 'returns 422' do
        expect(subject).to have_http_status(422)
      end
    end

    context 'with all required params' do
      let(:params) { { id: user_event.id, event: { name: 'Sanders Sled Race' } } }

      it 'returns 200' do
        expect(subject.response_code).to eq(200)
      end

      it 'updates the event' do
        response = JSON.parse(subject.body)
        expect(response['name']).to eq('Sanders Sled Race')
      end
    end
  end

  describe '#destroy' do
    before { request.headers['Authorization'] = 'Bearer good' }

    subject { delete :destroy, id: id }

    context 'event exists' do
      let(:id) { user_event.id }

      it 'returns 204' do
        expect(subject.response_code).to eq(204)
      end

      it 'deletes the event' do
        expect { subject }.to change { Event.exists?(id: user_event.id) }.from(true).to(false)
      end
    end
  end
end
