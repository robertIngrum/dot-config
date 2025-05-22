import { Action, ActionPanel, Detail, Form } from "@raycast/api";
import { useForm, FormValidation } from "@raycast/utils";
import { useState } from "react";

interface ChatFormValues {
	message: string;
}

export default function Command() {
	const [response, setResponse] = useState("");

	const { handleSubmit, itemProps } = useForm<ChatFormValues>({
		onSubmit(values) {
			setResponse("Yay");
		},
		validation: {
			message: FormValidation.Required,
		},
	});

	if (response)
		return <Detail 
			markdown={response} 
			actions={
				<ActionPanel title="Message Response">
					<Action title="New Message" onAction={() => setResponse("")} shortcut={{ modifiers: ["cmd"], key: "n" }} />
				</ActionPanel>
			}
		/>;

  return (
		<>
			<Form
				actions={
					<ActionPanel>
						<Action.SubmitForm title="Submit" onSubmit={handleSubmit} />
					</ActionPanel>
				}
			>
				<Form.TextArea 
					title="Message" 
					placeholder="What's Up?" 
					autoFocus={true}
					{...itemProps.message} />
			</Form>
		</>
	);
}
