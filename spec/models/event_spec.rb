describe Event do
  it { is_expected.to have_many(:signups) }
  it { is_expected.to have_many(:questions) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:slug) }
  it { is_expected.to validate_uniqueness_of(:slug) }

  it 'accepts nested attributes for questions' do
    params = {
      event: {
        name: 'Tester', questions_attributes: [
          { title: 'Tester', type: 'checkbox' }
        ]
      }
    }

    event = Event.create(params[:event])

    expect(event.questions.length).to eq(1)
  end

  describe '#self.default' do
    subject { Event.default }

    context 'default event does not exist' do
      it 'creates default event' do
        expect { subject }.to change { Event.count }.by(1)
      end

      it 'returns default event' do
        expect(subject.name).to eq('Default')
        expect(subject.slug).to eq('default')
      end
    end

    context 'default event exists' do
      before { Event.create(name: 'Default', slug: 'default') }

      it 'does not create default event' do
        expect { subject }.not_to change { Event.count }
      end

      it 'returns default event' do
        expect(subject.name).to eq('Default')
        expect(subject.slug).to eq('default')
      end
    end
  end
end
