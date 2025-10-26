class AddRoleToResponses < ActiveRecord::Migration[7.0]
  def change
    # Store respondent's role and theire response
    add_column :responses, :role, :string
    #Add index to group responses by roles 
    add_index  :responses, :role
  end
end
