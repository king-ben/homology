package beast.evolution.operators;

import beast.core.Description;
import beast.core.Input;
import beast.core.Input.Validate;
import beast.core.Operator;
import beast.core.parameter.IntegerParameter;
import beast.core.parameter.Parameter;
import beast.core.parameter.RealParameter;
import beast.util.Randomizer;
@Description("Operator that selects new homology states according to fixed input probabilities. The proposal is always accepted")

public class GibbsHomologyOperator extends Operator {
	public Input<IntegerParameter> homologyInput = new Input<>("parameter", "integer defining homology state", Validate.REQUIRED);
	public Input<RealParameter> conditionalProbs = new Input<>("conditionalProbabilities", "conditional probabilities of each homology state", Validate.REQUIRED);
	Parameter<?> parameter;
    int lowerIndex, upperIndex;
    double[] cp;
    int dim;
    double[] cumulative;
    
	@Override
	public void initAndValidate() {
		
		parameter = homologyInput.get();
    	lowerIndex = (Integer) parameter.getLower();
        upperIndex = (Integer) parameter.getUpper();
        cp = conditionalProbs.get().getDoubleValues();
		dim = conditionalProbs.get().getDimension();
		double sum=getSumOfProbs(cp);
		// Check that probabilities add up to one
        if (Math.abs(sum - 1.0) > 1e-6) {
            throw new IllegalArgumentException("Probabilities do not add up to 1");
        }
		cumulative = getCumulativeProbs(cp);
		// Check that number of conditional probabilities matches number of homology states
		if(upperIndex - lowerIndex +1 != dim) {
			throw new IllegalArgumentException("Number of conditional probabilities does not match number of possible homology states");
		}
	}

	@Override
	public double proposal() {
		// generate random number between 0 and 1
		double proposalRand = Randomizer.nextDouble();
		// Compare random number to cumulative probabilities to generate proposal
		int proposal=0;
		while(cumulative[proposal]<proposalRand) {
			proposal++;
		}
		// Reject if new state matches old, saves calculating posterior
		if(proposal==homologyInput.get().getValue()) {
			return Double.NEGATIVE_INFINITY;
		}
		// update homology parameter
		((IntegerParameter) parameter).setValue(0, proposal);
		// Always accepted i.e. Gibbs operator
		return Double.POSITIVE_INFINITY;
	}
	
	 /**
     * @param probabilities the probabilities
     * @return return the sum of probabilities
     */
    private double getSumOfProbs(double[] probs) {
        double total = 0.0;
        for (double prob : probs) {
            total += prob;
        }
        return total;
    }
    
    /**
     * @param probabilities the probabilities
     * @return return the cumulative probabilities e.g. if 0.2, 0.4, 0.4, will return 0.2, 0.6, 1.0
     */
    private double[] getCumulativeProbs(double[] probs) {
    	double[] cumulativeProbs = probs;
    	double tempProbs = 0;
    	for( int i = 0; i<probs.length; i++) {
            tempProbs += probs[i];
            cumulativeProbs[i] = tempProbs;
        }
    	return cumulativeProbs;
    }
}
