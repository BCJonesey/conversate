class AddReferrerToBetaSignup < ActiveRecord::Migration
  def change
    add_column :beta_signups, :referrer, :string, :default => nil
  end
end
