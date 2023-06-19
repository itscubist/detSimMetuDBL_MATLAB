% A function for Monte Carlo Analysis of given arbitrary PDF
% Returns an array of selected index with length "number"
% The probability of these indexes are determined by the given PDF

% Note : PDF should be normalized (summed to 1)

function selected_index  = pdf_event_generator(index, PDF, number)
   
   if (sum(PDF) < 0.9999 || sum(PDF) > 1.0001)
       Warning = ' This PDF is not properly normalized, it will be done now'
       PDF = PDF/sum(PDF);
   end
   
   selected_index = zeros(1,number);
   rand_array = rand(1,number);
   for i= 1:1:number
       probability_sum = 0;
       for j = 1:1:length(PDF)
           probability_sum  = probability_sum + PDF(j);
           if(rand_array(i) < probability_sum)
               selected_index(i) = index(j);
               break;
           end
       end
   end
   
end