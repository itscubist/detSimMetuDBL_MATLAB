% No need to look pdg for most used thin detectors
function outcell = energy_loss_database(instr)
    if(strcmp(instr,'silicon'))
        outcell = {'Silicon Z = 14 ', 'Silicon A = 28.0855' , ...
            'Si density = 2.379 gcm-3', 'Silicon meanIE = 175 eV' };
    end  
    if(strcmp(instr,'diamond'))
        outcell = {'Diamond Z = 6 ', 'Diamond A = 12.0107' , ...
            'Diamond density = 3.520 gcm-3', 'Diamond meanIE = 70 eV' };
    end
    if(strcmp(instr,'graphite'))
        outcell = {'Graphite Z = 6 ', 'Graphite A = 12.0107' , ...
            'graphite density = 2.210 gcm-3', 'Graphite meanIE = 70 eV' };
    end
end