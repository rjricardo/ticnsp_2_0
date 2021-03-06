class CoordinatorMailer < ApplicationMailer

	def welcome_coordinator(coordinator, init_password)
		@coordinator = coordinator
		@url = "http://ticnsp.org/users/sign_in"
		@init_password = init_password
		mail(to: ["#{@coordinator.email}","admin@ticnsp.org"], subject: 'Bienvenido al portal de TIC')
	end

  def notify_coordinator(coordinator, notification)
    @coordinator = coordinator
    @url = "http://ticnsp.org/"
    @notification = notification
    mail( to: [@coordinator.email], subject: "Avisos TIC - ")
  end

	def notice_coordinator(coordinator, notice)
    @coordinator = coordinator
    @url = "http://ticnsp.org/notices#notice_#{ notice.id }"
    @notice = notice
    mail( to: ["#{ @coordinator.email }", "admin@ticnsp.org" ], subject: "Avisos TIC - #{ notice.heading }" )
	end
end
