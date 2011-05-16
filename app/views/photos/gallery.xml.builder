cat = Category.find_by_name params[:category]
xml.instruct!
xml.simpleviewerGallery :maxImageWidth => '440',
                        :maxImageHeight => '440',
                        :textColor => '0x552222',
                        :frameColor => '0x552222',
                        :frameWidth => 15,
                        :stagePadding => 40,
                        :thumbnailColumns => 2,
                        :thumbnailRows => 4,
                        :navPosition => 'left',
                        :title => params[:category],
                        :enableRightClickOpen => true,
                        :imagePath => "/images/photos/category_#{cat.id}/",
                        :thumbPath => "/images/photos/category_#{cat.id}/" do
  @photos.each do |photo|
    xml.image do
      xml.filename File.basename(photo.filename)
      xml.caption photo.caption
    end
  end
end
