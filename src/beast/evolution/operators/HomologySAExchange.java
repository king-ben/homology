package beast.evolution.operators;

import beast.core.Description;
import beast.core.Input;
import beast.core.Input.Validate;
import beast.core.parameter.IntegerParameter;
import beast.core.parameter.Parameter;
import beast.evolution.tree.Tree;
import beast.util.Randomizer;
@Description("Implements an SA Exchange, but also changes the value of an input integer parameter that defines the current homology")

public class HomologySAExchange extends SAExchange{
	
	public Input<IntegerParameter> homologyInput =  new Input<>("homology", "integer defining the homology state", Validate.REQUIRED);
	
    Parameter<?> parameter;
    int lowerIndex, upperIndex;
    
    @Override
    public void initAndValidate() {
    	parameter = homologyInput.get();
    	lowerIndex = (Integer) parameter.getLower();
        upperIndex = (Integer) parameter.getUpper();
    }
    
    @Override
    public double proposal() {
    	//Changing homology state
    	
    	int newValue = Randomizer.nextInt(upperIndex - lowerIndex + 1) + lowerIndex;
    	((IntegerParameter) parameter).setValue(0, newValue);
    	
    	//Copied from Exchange
    	final Tree tree = treeInput.get(this);

        double logHastingsRatio = 0;

        if (isNarrowInput.get()) {
            logHastingsRatio = narrow(tree);
        } else {
            logHastingsRatio = wide(tree);
        }

        return logHastingsRatio;
    }
}
