class CreateComfyGallery < ActiveRecord::Migration
  def self.up
    unless table_exists?(:gallery_galleries)
      create_table :gallery_galleries do |t|
        t.string   :title,                             null: false
        t.string   :identifier,                        null: false
        t.text     :description
        t.integer  :full_width,        default: 1024
        t.integer  :full_height,       default: 768
        t.boolean  :force_ratio_full,  default: false, null: false
        t.integer  :thumb_width,       default: 150
        t.integer  :thumb_height,      default: 150
        t.boolean  :force_ratio_thumb, default: true,  null: false
        t.string   :layout
        t.timestamps
      end

      add_index :gallery_galleries, :identifier, :unique => true
    end

    unless table_exists?(:gallery_photos)
      create_table :gallery_photos do |t|
        t.integer  :gallery_id,                     null: false
        t.string   :title
        t.text     :description
        t.string   :image_file_name
        t.string   :image_content_type
        t.integer  :image_file_size
        t.integer  :position,           default: 0, null: false
        t.datetime :created_at
        t.datetime :updated_at
        t.text     :url
        t.text     :tags
        t.timestamps
      end

      add_index :gallery_photos, [ :gallery_id, :position ]
    end
  end

  def self.down
    drop_table :gallery_photos
    drop_table :gallery_galleries
  end
end



