class EventController < ApplicationController 

  def new
  	@event = Event.new
    @user = current_user
    @event.participates = Array.new

    # Add event creator(logged user) as a participate
    self_participate = Participate.new
    self_participate.user = @user
    @event.participates.push(self_participate)
  end

  def create
    @event = Event.new(event_params)
    if @event.save
     create_transactions(@event)
     flash[:notice] = "Successfully created event."
     redirect_to event_path(@event.id)
   else
     render :action => 'new'
   end
 end

  # def create
  #   @event = Event.find(18)
  #   create_transactions(@event)

  #   redirect_to event_path(@event.id)
  # end


  def show
  	@event = Event.find(params[:id])
  end

  def new_participant
    @participant = Participate.new
    @participant.user = User.find(params[:format])
    # puts 'new_participant called'
    # puts participant.inspect
  end

  def search_friend
    @results = User.search(params[:search])
    puts " Found results: #{ @results.length }"
  end

  def create_transactions(event)
    if(event != nil && event.participates != nil)

      # find sum of portion and total amount
      total_amount = 0.0;
      total_portion = 0.0;
      event.participates.each do |participate|
        total_amount = total_amount + participate.amount
        total_portion = total_portion + participate.portion
      end

      unit_portion_amount = total_amount / total_portion

      # init TransactionCalc 
      calc_list = Array.new
      event.participates.each do |participate|
        calc = TransactionCalc.new
        calc.user = participate.user
        calc.portion = participate.portion * unit_portion_amount
        calc.put = participate.amount
        calc.pay = calc.portion - calc.put

        calc_list.push(calc)
      end

      # init Transaction List
      transaction_list = Array.new
      all_zero = false
      interate = 0;
      while(!all_zero) do
        all_zero = true
        calc_list.each do |first|
          #TODO make continue if first.pay = 0 (already stable)

          calc_list.each do |second|
            #TODO make continue if second.pay = 0 (already stable)

            first_pay = first.pay
            second_pay = second.pay
            sum = first_pay + second_pay
            if(first.user != second.user && first_pay > 0 && second_pay < 0)
              if(sum >= 0 )
                # first => second : second.pay (first pays second an {second.pay} amount)
                puts "#{first.user.first_name} pays #{second.user.first_name} amount #{ second.pay }"

                first.pay = sum
                second.pay = 0
              else
                # first => second : first.pay
                puts "#{first.user.first_name} pays #{second.user.first_name} amount #{ first.pay }"
                first.pay = 0
                second.pay = sum

              end

            end


          end

          if(all_zero && first.pay != 0.0)
            all_zero = false
          end
        end

      end

    end
  end
  
  
  def event_params
    params.require(:event).permit(:name, :description, participate_attributes: [:user_id,:amount,:portion])
  end


end