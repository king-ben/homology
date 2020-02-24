package beast.evolution.likelihood;

import java.util.List;
import java.util.Random;

import beast.core.Description;
import beast.core.Distribution;
import beast.core.Input;
import beast.core.State;
import beast.core.Input.Validate;
@Description("Matches an input tree likelihood with a particular homology state")

public class HomologyTreeLikelihood extends Distribution {
	public Input<Distribution> Lik = new Input<>("input", "Tree Likelihood", Validate.REQUIRED);
	
	public Input<Integer> homologyInput = new Input<>("homologyState", "integer defining homology state", Validate.REQUIRED);

	@Override
	public double calculateLogP() {
		logP = 0;
		logP = Lik.get().calculateLogP();
        return logP;
    }
	
	public int getHomologyState() {
		int hom = homologyInput.get();
		return hom;
	}
	
	@Override
	public List<String> getArguments() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<String> getConditions() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void sample(State state, Random random) {
		// TODO Auto-generated method stub
		
	}

}
