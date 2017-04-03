/*
 * generated by Xtext 2.10.0
 */
package org.rmemory.xtext.entities.ui.quickfix

import org.eclipse.xtext.diagnostics.Diagnostic
import org.eclipse.xtext.ui.editor.quickfix.DefaultQuickfixProvider
import org.eclipse.xtext.ui.editor.quickfix.Fix
import org.eclipse.xtext.ui.editor.quickfix.IssueResolutionAcceptor
import org.eclipse.xtext.validation.Issue
import org.rmemory.xtext.entities.entities.EntitiesFactory
import org.rmemory.xtext.entities.entities.Entity
import org.rmemory.xtext.entities.entities.Model
import org.rmemory.xtext.entities.validation.EntitiesValidator

import static extension org.eclipse.xtext.EcoreUtil2.*

/**
 * Custom quickfixes.
 *
 * See https://www.eclipse.org/Xtext/documentation/310_eclipse_support.html#quick-fixes
 */
class EntitiesQuickfixProvider extends DefaultQuickfixProvider {
	
@Fix(Diagnostic.LINKING_DIAGNOSTIC)
def void createMissingEntity(Issue issue,
	IssueResolutionAcceptor acceptor) {
		acceptor.accept(issue,
			"Create missing entity",
			"Create missing entity",
			"Entity.gif",
			[element, context |
				val currentEntity = element.getContainerOfType(Entity)
				val model = currentEntity.eContainer as Model
				model.entities.add(
					model.entities.indexOf(currentEntity) + 1,
					EntitiesFactory.eINSTANCE.createEntity() => [
						name = context.xtextDocument.get(issue.offset, issue.length)]
					)
			] 
		)
	}

@Fix(EntitiesValidator.INVALID_ENTITY_NAME)
def void capitalizeEntityNameFirstLetter(Issue issue, 
	IssueResolutionAcceptor acceptor) {
 		changeFirstLetterToUpperCase(issue, acceptor)
	}
	
@Fix (EntitiesValidator.INVALID_ATTRIBUTE_NAME)
def void capitalizeAttributeFirstLetter(Issue issue,
	IssueResolutionAcceptor acceptor) {
		changeFirstLetterToUpperCase(issue, acceptor)
	}
	
@Fix (EntitiesValidator.HIERARCHY_CYCLE)
def void removeSuperType(Issue issue, 
	IssueResolutionAcceptor acceptor) {
		acceptor.accept(issue,
			"Remove SuperType",
			'''Remove supertype '«issue.data.get(0)» ''',
			"delete_obj.gif",
			[element, context | (element as Entity).superType = null]
		)
	}
	
protected def void changeFirstLetterToUpperCase(Issue issue, 
	IssueResolutionAcceptor acceptor) {
				acceptor.accept(issue,
			"Capitalize first letter", //label
			"Captialize first letter of '" + issue.data.get(0) + "'", // description
		    "Entity.gif", //icon
		    [context | 
		    	val xtextDocument = context.xtextDocument
		    	val firstLetter = xtextDocument.get(issue.offset, 1);
		    	xtextDocument.replace(issue.offset, 1, firstLetter.toFirstUpper)
		    ])
	}
//	@Fix(EntitiesValidator.INVALID_NAME)
//	def capitalizeName(Issue issue, IssueResolutionAcceptor acceptor) {
//		acceptor.accept(issue, 'Capitalize name', 'Capitalize the name.', 'upcase.png') [
//			context |
//			val xtextDocument = context.xtextDocument
//			val firstLetter = xtextDocument.get(issue.offset, 1)
//			xtextDocument.replace(issue.offset, 1, firstLetter.toUpperCase)
//		]
//	}
}
