package beast.evolution.likelihood;


import beast.core.Description;
import beast.core.Input;
import beast.core.Input.Validate;
@Description("Matches an input tree likelihood with a particular homology state")

public class HomologyTreeLikelihood extends TreeLikelihood {
	
	public Input<Integer> homologyInput = new Input<>("homologyState", "integer defining homology state", Validate.REQUIRED);

	
	
	public int getHomologyState() {
		int hom = homologyInput.get();
		return hom;
	}
	
	
	
	 @Override
	    protected boolean requiresRecalculation() {
	        
	            return true;
	        
	    }
	
	 
}
