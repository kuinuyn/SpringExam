<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="container">
	<form name='f' action='/loginProcess' method='POST'>
		<table>
			<tr>
				<td>User:</td>
				<td><input type='text' name='user_id' id="user_id" value=''></td>
			</tr>
			<tr>
				<td>Password:</td>
				<td><input type='password' name='pw' id="pw" /></td>
			</tr>
			<tr>
				<td colspan='2'><input name="submit" type="submit" value="Login" /></td>
			</tr>
		</table>
	</form>
</div>