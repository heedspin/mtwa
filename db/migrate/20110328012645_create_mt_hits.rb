class CreateMtHits < ActiveRecord::Migration
  def self.up
    create_table :mt_hits do |t|
      t.string   :hit_url
      t.boolean  :sandbox
      t.string   :task_type
      t.text     :hit_title
      t.text     :hit_description
      t.string   :hit_id
      t.decimal  :hit_reward, :precision => 10, :scale => 2
      t.integer  :hit_num_assignments
      t.integer  :hit_lifetime
      t.string   :form_url
      t.references :status
      t.string   :local_id
      t.text     :cookie_json
      t.timestamps
    end
  end

  def self.down
    drop_table :mt_hits
  end
end
