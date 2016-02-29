describe Api::V1::UsersController do
  let!(:user) { create(:user, email: 'bernie@berniesanders.com') }

  before do
    stub_request(:get, 'https://www.googleapis.com/oauth2/v1/userinfo?alt=json')
      .with(headers: { 'Authorization' => 'Bearer good' })
      .to_return(status: 200, body: { email: 'bernie@berniesanders.com' }.to_json, headers: {})
    request.headers['Authorization'] = 'Bearer good'
  end

  describe '#me' do
    subject { get :me }

    it 'returns role and access token' do
      response = JSON.parse(subject.body)
      expect(response['role']).to eq('user')
      expect(response['authToken']).to eq('good')
    end
  end
end
