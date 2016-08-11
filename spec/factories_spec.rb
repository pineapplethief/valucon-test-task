RSpec.describe FactoryGirl do
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  FactoryGirl.factories.map(&:name).each do |factory_name|
    describe "#{factory_name} factory" do
      it 'is valid' do
        factory = FactoryGirl.create(factory_name)
        expect(factory).to be_valid, -> { factory.errors.full_messages.join("\n") }
      end
    end
  end

end
