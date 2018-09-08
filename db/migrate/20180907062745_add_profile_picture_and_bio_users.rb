class AddProfilePictureAndBioUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :bio, :text
    add_column :users, :profile_picture, :string
  end
end
