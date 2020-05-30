package beast.evolution.likelihood;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import beast.core.Description;
import beast.core.Distribution;
import beast.core.Input;
import beast.core.State;
import beast.core.parameter.IntegerParameter;
import beast.core.parameter.Parameter;
@Description("Takes an input list of homology tree likelihoods and homology state parameter, and outputs the the tree likelihood that corresponds to the current homology state")

public class HomologyMultiplexer extends Distribution {
	final public Input<List<HomologyTreeLikelihood>> LikelihoodInput = new Input<>("homologyTreeLikelihood", "list of taxa making up the set", new ArrayList<>());
	public Input<IntegerParameter> homologyInput = new Input<>("homology", "integer defining homology state");
	Parameter<?> parameter;
    int lowerIndex, upperIndex;
	int currentState;
	HomologyTreeLikelihood tempDist;
	int tempState;
	int[] allStates;
	
	@Override
	public void initAndValidate() {
		//Check that number of input tree likelihoods is the same as the number of states of the homology parameter
		int[] allStates = new int[LikelihoodInput.get().size()];
		parameter = homologyInput.get();
    	lowerIndex = (Integer) parameter.getLower();
        upperIndex = (Integer) parameter.getUpper();
        if(upperIndex-lowerIndex+1 != LikelihoodInput.get().size()) {
        	throw new IllegalArgumentException("Number of Homology states does not match number of input tree Likelihoods");
        }
        //Check that homology states conform to 0, 1, 2 ... n
        for(int i=0; i<LikelihoodInput.get().size(); i++) {
        	tempDist = LikelihoodInput.get().get(i);
        	allStates[i] = tempDist.getHomologyState();
        }
        int total = 0;
        for (double state : allStates) {
            total += state;
        }
        int n = LikelihoodInput.get().size()-1;
        int sigma = n*(n+1)/2;
        if(total != sigma) {
        	throw new IllegalArgumentException("Homology states should be assigned in sequence starting with 0");
        }
	}
	
    protected double storedLogP = Double.NaN;
	@Override
	public double calculateLogP() {
		logP = 0;
		// find current state of homology parameter
		currentState = homologyInput.get().getValue();
		// Calculate tree likelihood for the relevant homology state
		for(int i=0; i<LikelihoodInput.get().size(); i++) {
			tempDist = LikelihoodInput.get().get(i);
			if(tempDist.getHomologyState()==currentState) {
				logP=tempDist.calculateLogP();
			}
			
		}
		return logP;
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
	
	@Override
    protected boolean requiresRecalculation() {
        
            return true;
        
    }
}
