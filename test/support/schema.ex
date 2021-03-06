defmodule Schema.Types do
  use Absinthe.Schema.Notation

  object :mutation_fields do
    field :add_comment, :comment do
      arg :contents, non_null(:string)

      resolve fn %{contents: contents}, _ ->
        comment = %{contents: contents}
        {:ok, comment}
      end
    end
  end
end

defmodule Schema do
  use Absinthe.Schema

  import_types Schema.Types

  object :comment do
    field :contents, :string
  end

  object :user do
    field :name, :string
    field :age, :integer
  end

  query do
    field :users, list_of(:user) do
      resolve fn _, _ ->
        users = [
          %{name: "Bob", age: 29}
        ]
        {:ok, users}
      end
    end
  end

  mutation do
    import_fields :mutation_fields
  end

  subscription do
    field :comment_added, :comment do
      config fn _args, _info ->
        {:ok, topic: ""}
      end

      trigger :add_comment, topic: fn _comment ->
        ""
      end
    end

    field :raises, :comment do
      config fn _, _ ->
        {:ok, topic: "raise"}
      end

      trigger :add_comment, topic: fn comment ->
        comment.contents
      end

      resolve fn _, _ -> raise "boom" end
    end
  end
end
