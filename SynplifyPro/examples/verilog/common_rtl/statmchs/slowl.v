`timescale 100 ps/100 ps
/*
 * predict the next entry in the input
 * stream of results
 */
module slow_learner(rst,guess, result, clk);
output guess;
input rst,result, clk;

reg guess;

always begin :main
	guess = 0;
	@(posedge clk or posedge rst);
	if (rst) disable main;
	while(1) begin
		while(!result ) begin
			guess = 0;
			while(!result ) begin
				@(posedge clk or posedge rst);
				if (rst) disable main;
			end	
			@(posedge clk or posedge rst);
			if (rst) disable main;
		end
		while(result) begin
			guess = 1;
			while(result) begin
				@(posedge clk or posedge rst);
				if (rst) disable main;
			end
			@(posedge clk or posedge rst);
			if (rst) disable main;
		end
	end
end

endmodule

