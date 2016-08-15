RSpec.describe BaseUploader do
  let(:task) { build_stubbed(:task) }
  subject(:uploader) { described_class.new(task, :file) }

  before do
    described_class.enable_processing = true
  end

  describe '#store_dir' do
    it 'returns proper file_path based on uploader model' do
      expect(uploader.store_dir).to eq("uploads/task/file/#{task.id}")
    end
  end

  describe '#image?' do
    context 'when file is an image' do
      before do
        File.open(fixture_image_path) { |file| uploader.store!(file) }
      end

      it 'returns true' do
        expect(uploader.image?).to be true
      end
    end
    context 'when file is not an image' do
      before do
        File.open(fixture_file_path) { |file| uploader.store!(file) }
      end

      it 'returns false' do
        expect(uploader.image?).to be false
      end
    end
  end
end
