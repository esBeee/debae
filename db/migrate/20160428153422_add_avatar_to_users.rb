class AddAvatarToUsers < ActiveRecord::Migration[5.0]
  # :add_attachment and :remove_attachment methods are provided vy the paperclip gem.
  def self.up
    add_attachment :users, :avatar
  end

  def self.down
    remove_attachment :users, :avatar
  end
end
