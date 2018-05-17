class RegisterUser
  prepend SimpleCommand

  def initialize(params = {})
    @params = params
  end

  def call
    user
  end

  private

  attr_accessor :email, :password, :password_confirmation

  def user
    user = User.create!([name:@params[:name], surname: @params[:surname], email: @params[:email], password: @params[:password], password_confirmation: @params[:password_confirmation]])
    @user = user[0]
    begin
      @user.create_role(role_type: Role::UNDEFINED_ROLE)
    rescue => ex
      @user.destroy
      @user = nil
      errors.add( :role, 'Cant create user with this role')
    end

    if @user
      return @user
    end

    nil
  end
end