describe Question do
  it { is_expected.to belong_to(:event) }

  describe 'validation of type field' do
    it 'accepts checkbox' do
      question = FactoryGirl.build(:question, type: 'checkbox')
      expect(question.valid?).to eq(true)
    end

    it 'accepts text' do
      question = FactoryGirl.build(:question, type: 'text')
      expect(question.valid?).to eq(true)
    end

    it 'does not accept datetime' do
      question = FactoryGirl.build(:question, type: 'datetime')
      expect(question.valid?).to eq(false)
    end
  end
end
