class AddVisibleForRolesToQuestions < ActiveRecord::Migration[7.0]
  def change
    """add a json array with an empty array(visible to everyone)"""
    add_column :questions, :visible_for_roles, :jsonb, null:false, default:[]

    # GIN-Generalized Inverted Index index to increase look up speed like : show me questions visible to SWE
    add_index :questions, :visible_for_roles, using: :gin, name: "index_questions_on_visible_for_roles_gin"

    #enforcing array shape at db level, to prevent later accidental updated to json
    execute <<~SQL
      ALTER TABLE questions
      ADD CONSTRAINT chk_questions_visible_for_roles_is_array
      CHECK (jsonb_typeof(visible_for_roles) = 'array');
    SQL
  end
end
