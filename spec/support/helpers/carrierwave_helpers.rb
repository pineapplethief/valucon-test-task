module CarrierwaveHelpers
  def fixture_image_path
    Rails.root.join 'spec', 'fixtures', 'images', 'band_candy.jpg'
  end

  def fixture_file_path
    Rails.root.join 'spec', 'fixtures', 'files', 'hello_world.txt'
  end
end
